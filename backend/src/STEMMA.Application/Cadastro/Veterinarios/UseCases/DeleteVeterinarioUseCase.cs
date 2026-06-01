using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.Veterinarios.UseCases;

public class DeleteVeterinarioUseCase
{
    private readonly IVeterinarioRepository _repository;

    public DeleteVeterinarioUseCase(
        IVeterinarioRepository repository)
    {
        _repository = repository;
    }

    public async Task ExecuteAsync(Guid id)
    {
        var veterinario =
            await _repository.ObterPorIdAsync(id);

        if (veterinario is null)
            throw new Exception(
                "Veterinário não encontrado.");

        await _repository.RemoverAsync(id);
    }
}