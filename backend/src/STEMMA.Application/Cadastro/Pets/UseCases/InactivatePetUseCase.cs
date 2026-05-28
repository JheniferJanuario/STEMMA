using STEMMA.Domain.Cadastro.Enums;
using STEMMA.Domain.Cadastro.Repositories;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Cadastro.UseCases.Pet;

public class InactivatePetUseCase
{
    private readonly IPetRepository _petRepository;
    private readonly IConsultaRepository _consultaRepository;

    public InactivatePetUseCase(
        IPetRepository petRepository,
        IConsultaRepository consultaRepository)
    {
        _petRepository = petRepository;
        _consultaRepository = consultaRepository;
    }

    public async Task ExecuteAsync(Guid petId)
    {
        var pet = await _petRepository.ObterPorIdAsync(petId);

        if (pet == null)
            throw new Exception("Pet não encontrado.");

        var consultasFuturas = await _consultaRepository
            .ListarFuturasPorPetAsync(petId);

        if (consultasFuturas.Any())
            throw new Exception("Não é possível inativar pet com consultas futuras.");

        pet.AlterarStatus(StatusPet.Inativo);

        await _petRepository.AtualizarAsync(pet);
    }
}