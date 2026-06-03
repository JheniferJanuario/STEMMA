using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.Prontuarios.UseCases;

public class GetProntuariosByPetUseCase
{
    private readonly IProntuarioRepository _repository;

    public GetProntuariosByPetUseCase(
        IProntuarioRepository repository)
    {
        _repository = repository;
    }

    public async Task<List<Prontuario>> ExecuteAsync(Guid petId)
    {
        return await _repository.ObterPorPetIdAsync(petId);
    }
}